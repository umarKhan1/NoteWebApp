import 'dart:convert';
import 'dart:js_interop';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:web/web.dart' as web;

import '../../domain/entities/note.dart';

/// Enum for markdown element types
enum MarkdownElementType {
  /// Header element
  header,

  /// Paragraph element
  paragraph,

  /// List item element
  listItem,

  /// Code block element
  codeBlock,
}

/// Class to represent markdown elements for PDF generation
class MarkdownElement {
  /// Private constructor
  MarkdownElement._(this.type, this.content, [this.level = 0]);

  /// Factory constructor for header elements
  factory MarkdownElement.header(String content, int level) =>
      MarkdownElement._(MarkdownElementType.header, content, level);

  /// Factory constructor for paragraph elements
  factory MarkdownElement.paragraph(String content) =>
      MarkdownElement._(MarkdownElementType.paragraph, content);

  /// Factory constructor for list item elements
  factory MarkdownElement.listItem(String content) =>
      MarkdownElement._(MarkdownElementType.listItem, content);

  /// Factory constructor for code block elements
  factory MarkdownElement.codeBlock(String content) =>
      MarkdownElement._(MarkdownElementType.codeBlock, content);

  /// The type of markdown element
  final MarkdownElementType type;

  /// The content of the element
  final String content;

  /// The heading level for header elements
  final int level;
}

/// Service for generating and managing PDF exports of notes
class NotePdfService {
  /// Generate and download a PDF of the note
  static Future<void> downloadNotePdf(Note note) async {
    try {
      final pdf = await _generatePdf(note);
      final bytes = await pdf.save();

      await Printing.sharePdf(
        bytes: bytes,
        filename: '${_sanitizeFilename(note.title)}.pdf',
      );
    } catch (e) {
      try {
        await _fallbackWebDownload(note);
      } catch (fallbackError) {
        throw Exception(
          'Failed to download PDF: $e. Fallback also failed: $fallbackError',
        );
      }
    }
  }

  /// Print a PDF of the note
  static Future<void> printNotePdf(Note note) async {
    try {
      final pdf = await _generatePdf(note);
      await Printing.layoutPdf(
        onLayout: (format) async {
          return await pdf.save();
        },
      );
    } catch (e) {
      throw Exception('Failed to print PDF: $e');
    }
  }

  /// Generate a PDF document from a note
  static Future<pw.Document> _generatePdf(Note note) async {
    final pdf = pw.Document();

    // Process markdown content properly
    final processedContent = _processMarkdownForPdf(note.content);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Title Section
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  _cleanText(note.title),
                  style: const pw.TextStyle(
                    fontSize: 24,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Container(height: 3, width: 80, color: PdfColors.blue600),
              ],
            ),
          ),

          // Metadata Section
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 24),
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (note.category != null) ...[
                  pw.Row(
                    children: [
                      pw.Text(
                        'Category: ',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.Text(
                        _cleanText(note.category!),
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                ],
                pw.Row(
                  children: [
                    pw.Text(
                      'Created: ',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.Text(
                      _formatDate(note.createdAt),
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  children: [
                    pw.Text(
                      'Last Updated: ',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.Text(
                      _formatDate(note.updatedAt),
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                if (note.isPinned) ...[
                  pw.SizedBox(height: 6),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      'Pinned Note',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Image Section (if available)
          if (note.imageBase64 != null && note.imageBase64!.isNotEmpty) ...[
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    constraints: const pw.BoxConstraints(maxWidth: 400),
                    child: pw.Image(
                      pw.MemoryImage(
                        base64Decode(_cleanBase64(note.imageBase64!)),
                      ),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  if (note.imageName != null && note.imageName!.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Image: ${note.imageName}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Content Section
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: _buildMarkdownContent(processedContent),
            ),
          ),
        ],
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 20),
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey300, width: 1),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by NoteWebApp',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf;
  }

  /// Process markdown content for better PDF rendering
  static List<MarkdownElement> _processMarkdownForPdf(String markdown) {
    final lines = markdown.split('\n');
    final elements = <MarkdownElement>[];
    final currentParagraph = <String>[];

    for (var line in lines) {
      line = line.trim();

      if (line.isEmpty) {
        if (currentParagraph.isNotEmpty) {
          elements.add(MarkdownElement.paragraph(currentParagraph.join(' ')));
          currentParagraph.clear();
        }
        continue;
      }

      // Headers
      if (line.startsWith('#')) {
        if (currentParagraph.isNotEmpty) {
          elements.add(MarkdownElement.paragraph(currentParagraph.join(' ')));
          currentParagraph.clear();
        }

        var level = 0;
        while (level < line.length && line[level] == '#') {
          level++;
        }
        final text = line.substring(level).trim();
        elements.add(MarkdownElement.header(text, level));
        continue;
      }

      // Code blocks
      if (line.startsWith('```')) {
        if (currentParagraph.isNotEmpty) {
          elements.add(MarkdownElement.paragraph(currentParagraph.join(' ')));
          currentParagraph.clear();
        }
        elements.add(MarkdownElement.codeBlock('[Code Block]'));
        continue;
      }

      // Lists
      if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          RegExp(r'^\d+\.').hasMatch(line)) {
        if (currentParagraph.isNotEmpty) {
          elements.add(MarkdownElement.paragraph(currentParagraph.join(' ')));
          currentParagraph.clear();
        }
        elements.add(
          MarkdownElement.listItem(
            line.replaceFirst(RegExp(r'^[-*\d.]\s*'), ''),
          ),
        );
        continue;
      }

      // Regular text
      currentParagraph.add(line);
    }

    if (currentParagraph.isNotEmpty) {
      elements.add(MarkdownElement.paragraph(currentParagraph.join(' ')));
    }

    return elements;
  }

  /// Build PDF content from processed markdown
  static List<pw.Widget> _buildMarkdownContent(List<MarkdownElement> elements) {
    final widgets = <pw.Widget>[];

    for (final element in elements) {
      switch (element.type) {
        case MarkdownElementType.header:
          widgets.add(pw.SizedBox(height: element.level == 1 ? 20 : 16));
          widgets.add(
            pw.Text(
              _cleanText(element.content),
              style: pw.TextStyle(
                fontSize: element.level == 1
                    ? 20
                    : (element.level == 2 ? 16 : 14),
                color: PdfColors.grey900,
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 8));
          break;

        case MarkdownElementType.paragraph:
          widgets.add(pw.SizedBox(height: 8));
          widgets.add(
            pw.Text(
              _cleanText(element.content),
              style: const pw.TextStyle(
                fontSize: 11,
                lineSpacing: 1.4,
                color: PdfColors.grey800,
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 8));
          break;

        case MarkdownElementType.listItem:
          widgets.add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '- ',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      _cleanText(element.content),
                      style: const pw.TextStyle(
                        fontSize: 11,
                        lineSpacing: 1.4,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;

        case MarkdownElementType.codeBlock:
          widgets.add(pw.SizedBox(height: 8));
          widgets.add(
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                element.content,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 8));
          break;
      }
    }

    return widgets;
  }

  /// Clean text from Unicode characters that might cause issues
  static String _cleanText(String text) {
    String cleaned = text;

    // Replace common Unicode characters with ASCII equivalents step by step
    cleaned = cleaned
        // Emojis
        .replaceAll('✨', '*')
        .replaceAll('🎯', '>')
        .replaceAll('📝', '[Note]')
        .replaceAll('📋', '[List]')
        .replaceAll('✅', '[Done]')
        .replaceAll('❌', '[X]')
        .replaceAll('⚠️', '[Warning]')
        .replaceAll('💡', '[Idea]')
        .replaceAll('🔗', '[Link]')
        .replaceAll('📚', '[Book]')
        .replaceAll('🔍', '[Search]')
        // Bullet points
        .replaceAll('•', '-')
        .replaceAll('◦', '-')
        .replaceAll('▪', '-')
        .replaceAll('▫', '-')
        .replaceAll('‣', '-')
        .replaceAll('⁃', '-')
        // Quotation marks
        .replaceAll('"', '"') // Left double quotation mark
        .replaceAll('"', '"') // Right double quotation mark
        .replaceAll(''', "'")  // Left single quotation mark
        .replaceAll(''', "'") // Right single quotation mark
        // Dashes and hyphens
        .replaceAll('—', '-')
        .replaceAll('–', '-')
        // Other common symbols
        .replaceAll('…', '...')
        .replaceAll('×', 'x')
        .replaceAll('©', '(c)')
        .replaceAll('®', '(R)')
        .replaceAll('™', '(TM)')
        .replaceAll('°', ' degrees');

    // Remove any remaining non-ASCII characters to be absolutely safe
    cleaned = cleaned.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    return cleaned.trim();
  }

  // Fallback web download
  static Future<void> _fallbackWebDownload(Note note) async {
    final pdf = await _generatePdf(note);
    final bytes = await pdf.save();

    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'application/pdf'),
    );
    final url = web.URL.createObjectURL(blob);

    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = '${_sanitizeFilename(note.title)}.pdf';

    web.document.body?.appendChild(anchor);
    anchor.click();
    web.document.body?.removeChild(anchor);
    web.URL.revokeObjectURL(url);
  }

  // Utilities
  static String _formatDate(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} at $h:$m';
  }

  static String _sanitizeFilename(String filename) {
    var s = filename
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    if (s.length > 50) s = s.substring(0, 50);
    return s.isEmpty ? 'note' : s;
  }

  static String _cleanBase64(String base64String) {
    if (base64String.contains(',')) {
      return base64String.split(',').last;
    }
    return base64String;
  }
}
