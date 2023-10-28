# API Documentation

This documentation provides details about the endpoints and operations for the API.

# Table of Contents

1. [User Authentication](#user-authentication)
   - [Signup (POST)](#signup-post)
   - [Login (POST)](#login-post)
2. [Blogs](#blogs)
   - [Get All Blogs (GET)](#get-all-blogs-get)
   - [Add New Blog (POST)](#add-new-blog-post)
   - [Update Blog (PUT)](#update-blog-put)
   - [Delete Blog (DELETE)](#delete-blog-delete)
   - [Get Blog Comment (GET)](#get-blog-comment-get)
3. [Comments](#comments)
   - [Add New Comment (POST)](#add-new-comment-post)
4. [Portfolios](#portfolios)
   - [Add New Portfolio (POST)](#add-new-portfolio-post)
   - [Get All Portfolios (GET)](#get-all-portfolios-get)
   - [Update Portfolio (PUT)](#update-portfolio-put)
   - [Delete Portfolio (DELETE)](#delete-portfolio-delete)
   - [Get User Portfolios (GET)](#get-user-portfolios-get)
5. [Contact Us](#contact-us)
   - [Contact Us Form (POST)](#contact-us-form-post)
6. [Users](#users)
   - [Get All Users (GET)](#get-all-users-get)
   - [Update User (POST)](#update-user-post)

---

## User Authentication

### Signup (POST)

Create a new user account.

**Endpoint:** `/auth`

**Body (JSON)**

```
{
    "username": "Example",
    "email": "example@gmail.com",
    "password": "Test@123"
}
```

### Login (POST)

- User login.

Endpoint: `/auth`

**Body (JSON)**

```
{
    "email": "anand1@gmail.com",
    "password": "Test@123"
}
```

---

## Blogs

### Get All Blogs (GET)

- Retrieve a list of all blogs.

**Endpoint:** `/blog`

**Authorization:** `Bearer Token`

### Add New Blog (POST)

- Create a new blog.

**Endpoint:** `/blog`

**Authorization:** `Bearer Token`

**Body (JSON)**

```

{
    "title": "The Art of Mindful Cooking",
    "content": "In this blog, we explore the concept of mindful cooking and how it can transform your relationship with food. Discover the joy of cooking with intention and savoring every bite.",
    "imageUrl": "https://t4.ftcdn.net/jpg/03/32/75/39/360_F_332753934_tBacXEgxnVplFBRyKbCif49jh0Wz89ns.jpg",
    "category": "Cooking"
}

```

### Update Blog

- Update an existing blog by ID.

**Endpoint:** `/blog/:id`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "title": "New Title",
    "content": "New Content",
    "imageUrl": "New imageUrl",
    "category": "New Technology"
}
```

### Delete Blog (DELETE)

**Endpoint:** `/blog/:id`

**Authorization:** `Bearer Token`

---

## Comments

### Get Blog Comment (GET)

- Retrieve comments for a specific blog.

**Endpoint:** `/comment`

**Authorization:** `Bearer Token`

### Add New Comment (POST)

- Add a new comment to a blog.

**Endpoint:** `/comment`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "content": "This is Commnet",
    "blog_id": 1,
    "user_id": 1
}
```

---

## Portfolios

### Add New Portfolio (POST)

- Create a new portfolio entry.

**Endpoint:** `/portfolio`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "title": "Task Management System",
    "description": "Build a task management system that allows users to create, assign, and track tasks. The system should have user roles, notifications, and a dashboard for task management.",
    "technologiesUsed": " Ruby on Rails, PostgreSQL, HTML, CSS, JavaScript",
    "githubLink": "https://github.com/yourusername/task-management-system"
}
```

### Get All Portfolios (GET)

- Retrieve a list of all portfolios.

**Endpoint:** `/portfolio`

**Authorization:** `Bearer Token`

### Update Portfolio (PUT)

- Update an existing portfolio by ID.

**Endpoint:** `/portfolio/:id`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "title": "Updated Testing",
    "description": "Updated Description",
    "technologiesUsed": "Flutter",
    "githubLink": "Updated Github Link"
}
```

### Delete Portfolio (DELETE)

- Delete a portfolio entry by ID.

**Endpoint:** `/portfolio/:id`

**Authorization:** `Bearer Token`

### Get User Portfolios

- Retrieve portfolios for a specific user.

**Endpoint:** `/portfolio/:id`

**Authorization:** `Bearer Token`

---

## Contact Us

### Contact Us Form (POST)

- Submit a contact form.

**Endpoint:** `/contact_form`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "title": "Title",
    "description": "Description",
    "senderName": "Sender Name",
    "receiverName": "Receiver Name",
    "senderEmail": "Sender Email",
}
```

---

## Users

### Get All Users (GET)

- Retrieve a list of all users.

**Endpoint:** `/user`

**Authorization:** `Bearer Token`

### Update User (POST)

- Update user information.

**Endpoint:** `/user`

**Authorization:** `Bearer Token`

**Body (JSON)**

```
{
    "username": "new username",
    "email": "new email",
    "bio": "New Bio",
    "profile_picture_url": "New URL",
    "contact_details": "new contact details"
}
```

---
