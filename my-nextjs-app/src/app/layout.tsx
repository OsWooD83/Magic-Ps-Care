import React from 'react';
import './globals.css';

const RootLayout = ({ children }) => {
  return (
    <html lang="en">
      <head>
        <title>My Next.js App</title>
      </head>
      <body>
        <header>
          <h1>Welcome to My Next.js App</h1>
        </header>
        <main>{children}</main>
        <footer>
          <p>&copy; {new Date().getFullYear()} My Next.js App</p>
        </footer>
      </body>
    </html>
  );
};

export default RootLayout;