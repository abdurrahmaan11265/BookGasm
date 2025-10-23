# BookGasm

BookGasm is a simple book management web app built with Express and EJS, featuring local authentication and Google OAuth. Users can register/login, add books with ISBN-based covers, search, sort, and delete their own books.

## Features
- **Authentication**: Local (email/password) with bcrypt, plus Google OAuth.
- **Books CRUD (user-scoped)**: Add, list, search, sort by title/rating, delete.
- **PostgreSQL persistence**: `users` and `books` tables with FK and composite PK.
- **Templating & static assets**: EJS views in `views/`, static files in `public/`.

## Tech Stack
- **Server**: Node.js, Express (`type: module`)
- **View engine**: EJS
- **Auth**: passport, passport-local, passport-google-oauth2, express-session
- **DB**: PostgreSQL via `pg`
- **Security**: helmet (dependency present), bcrypt

## Project Structure
```
BookGasm/
  app.js               # Main Express app
  package.json         # Scripts and dependencies
  .env.example         # Environment variables template
  queries.sql          # Database schema
  public/              # Static assets (css, images)
  views/               # EJS templates (home, register, index, book-form)
```

## Requirements
- Node.js and npm
- PostgreSQL (local or hosted)

## Setup
1. **Install dependencies**
   ```bash
   npm install
   ```
2. **Configure environment**
   Copy `.env.example` to `.env` and fill values
   - `SESSION_SECRET`: any strong random string.
   - For Google OAuth, create OAuth 2.0 credentials (Google Cloud Console) and set authorized redirect URI to the value of `GOOGLE_CALLBACK_URL`.
3. **Create database schema**
   - Run the SQL in `queries.sql` against your database to create `users` and `books` tables.
   - The app connects using the `.env` values. In `app.js`, SSL is configured as `{ rejectUnauthorized: false }` which is suitable for many hosted DBs. Adjust if needed.

## Run
```bash
npm start
# runs: node app.js (listens on PORT or 3000)
```
Then open `http://localhost:3000`.

## Test Credentials
Use the following credentials to log in:
- **Email**: khiladi@example.com
- **Password**: maihudon

## Scripts
- **start**: `node app.js`

Tip: for development, you can run `npx nodemon app.js`.

## Routes
- **GET /**: Home page (`views/home.ejs`)
- **GET /register**: Registration page (`views/register.ejs`)
- **POST /register**: Create local user (email + hashed password)
- **POST /**: Local login via Passport LocalStrategy (username=email, password)
- **GET /auth/google**: Start Google OAuth
- **GET /auth/google/books**: OAuth callback; redirects to `/books` on success
- **POST /logout**: End session and redirect to `/`
- **GET /books**: List authenticated user’s books
  - Query params:
    - `q`: search by title (ILIKE)
    - `sort`: `rating` (desc) or `title` (asc)
- **GET /add**: Render add-book form (`views/book-form.ejs`)
- **POST /add**: Add a book for the current user
  - Body: `id` (ISBN), `title`, `author`, `summary`, `link`, `rating`
  - Cover image is derived from OpenLibrary by ISBN: `https://covers.openlibrary.org/b/isbn/{id}-M.jpg`
- **POST /delete/:id**: Delete the book with the given `id` for the current user

## Database Schema
See `queries.sql` for the authoritative schema. Summary:
- **users**
  - `user_id` SERIAL PK
  - `email` UNIQUE
  - `password` nullable (Google-only users may not have a local password)
- **books**
  - Composite PK: `(id, user_id)`
  - Fields: `id` (ISBN), `title`, `author`, `summary`, `image`, `link`, `rating`, `user_id` FK→`users.user_id`
  - FK has `ON UPDATE CASCADE ON DELETE CASCADE`

## Views & Assets
- `views/home.ejs`, `views/register.ejs`, `views/index.ejs`, `views/book-form.ejs`
- `public/styles.css`, `public/utility.css`, `public/logo.png`

## Notes
- Ensure sessions are working by setting `SESSION_SECRET`.
- For Google OAuth, set `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, and `GOOGLE_CALLBACK_URL`.
- The app uses Express sessions and `passport.serializeUser`/`deserializeUser` to attach the full user object to `req.user`.


