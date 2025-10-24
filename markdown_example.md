# Markdown Features Example

This is a comprehensive example showing various markdown features and how they render in PDF export.

## Text Formatting

### Basic Text
This is regular paragraph text that works perfectly in PDF export. You can write long paragraphs and they will be formatted nicely with proper line spacing and word wrapping.

### Headers Work Great
Headers from H1 to H6 are fully supported and render with appropriate sizing.

#### Smaller Header
Even smaller headers maintain good hierarchy.

##### Very Small Header
All header levels work consistently.

## Lists Are Fully Supported

### Bullet Lists
- First item in the list
- Second item with more content
- Third item that might be longer and wrap to multiple lines
- Fourth item

### Numbered Lists
1. First numbered item
2. Second numbered item
3. Third numbered item with longer content that demonstrates wrapping
4. Fourth numbered item

### Nested Lists
- Main item
  - Sub item one
  - Sub item two
- Another main item
  - Another sub item

## Code and Technical Content

### Code Blocks
```javascript
function hello() {
    console.log("Hello World!");
    return true;
}
```

### Inline Code
Use `console.log()` for debugging. Note: inline code renders as plain text in PDF.

## Text with Special Characters

### ASCII Works Perfect
- Use asterisks (*) instead of star emojis
- Use greater than (>) instead of arrow emojis
- Use [Note] instead of note emojis
- Use [Done] instead of checkmark emojis

### What Gets Converted in PDF
- Stars: * (instead of ✨)
- Arrows: > (instead of 🎯)
- Notes: [Note] (instead of 📝)
- Lists: [List] (instead of 📋)
- Done: [Done] (instead of ✅)
- Warning: [Warning] (instead of ⚠️)
- Ideas: [Idea] (instead of 💡)

## Structural Elements

### Quotes and References
> This is a blockquote that shows quoted text
> It can span multiple lines
> But in PDF it renders as regular paragraphs

### Horizontal Rules
---

### Links and References
Visit [Google](https://google.com) - links render as plain text in PDF
Email: contact@example.com

### Tables (Not Supported in PDF)
| Feature | PDF Support | Notes |
|---------|-------------|-------|
| Headers | Yes | Perfect |
| Lists | Yes | Perfect |
| Tables | No | Renders as text |

## Best Practices for PDF Export

### Do Use:
- Clear headers for organization
- Bullet and numbered lists
- Plain text content
- Simple formatting
- ASCII characters

### Avoid for PDF:
- Emojis and Unicode symbols
- Complex tables
- Images
- Rich text formatting
- Special characters

## Example Note Content

### Meeting Notes - October 24, 2025

#### Attendees
- John Smith
- Jane Doe
- Bob Johnson

#### Action Items
1. Review project requirements
2. Update documentation
3. Schedule follow-up meeting
4. Send summary to team

#### Key Decisions
- Approved new feature implementation
- Set deadline for December 1st
- Allocated additional resources
- Agreed on testing strategy

### Project Planning

#### Phase 1: Research
- Market analysis
- Competitor research
- User interviews
- Technical feasibility

#### Phase 2: Development
- Design mockups
- Backend development
- Frontend implementation
- Testing and QA

#### Phase 3: Launch
- Deployment
- Marketing campaign
- User onboarding
- Performance monitoring

## Technical Documentation

### API Endpoints
```
GET /api/notes
POST /api/notes
PUT /api/notes/:id
DELETE /api/notes/:id
```

### Configuration
```yaml
app:
  name: NoteWebApp
  version: 1.0.0
  environment: production
```

### Error Codes
- 200: Success
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Server Error

This example demonstrates all the markdown features that work reliably in PDF export while avoiding problematic elements like emojis and complex formatting.
