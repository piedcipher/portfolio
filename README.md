# tirth.today

my portfolio site

Use the **Dark theme** / **Light theme** control on the home page to switch between themes.

Blog posts can display a staggered photo gallery by placing consecutive Markdown
images between `<!-- gallery -->` and `<!-- /gallery -->` markers. Store the
images directly in `assets/blogs_assets/` and use paths such as
`blogs_assets/photo.jpg` in the Markdown.

## Screenshots

| Desktop | Mobile |
| --- | --- |
| ![Portfolio desktop screenshot](https://github.com/user-attachments/assets/d9387daa-32fd-4300-a52a-3952d40a972f) | ![Portfolio mobile screenshot](https://github.com/user-attachments/assets/9471a3b7-8fbd-4869-9e58-12838b56239e) |

## Testing

This project includes Flutter widget tests.

### Run All Tests
```bash
flutter test
```

### Test Files
- **`test/home_page_test.dart`** - HomePage widget tests for title, tagline, theme toggle, and social media rendering
- **`test/mobile_navigation_test.dart`** - Mobile responsiveness tests for hamburger menu and drawer navigation
- **`test/blog_photo_gallery_test.dart`** - Blog photo gallery responsive layout tests
