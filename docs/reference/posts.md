# 📝 Posts API Reference

## 🔍 Filtering
The `GET /posts` endpoint supports filtering by query parameters.

### Filter by User (Author)
*   **Query Param**: `filter[userId]` (Matches Frontend `qs` format)
*   **Backend Map**: Maps to `author_id` column.
*   **Example**: `GET /posts?filter[userId]=1`
*   **Response**: List of posts authored by User ID 1.

### Behavior
*   If `userId` is invalid or no posts found: Returns `200 OK` with `data: []` and header `x-total-count: 0`.
*   If no filter provided: Returns all posts.

## 💾 Database Schema
*   Table `blog.post` now includes `author_id` (Integer, Nullable).
*   Future improvement: Add Foreign Key constraint to `blog.users`.
