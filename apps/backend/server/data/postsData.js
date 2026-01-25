const database = require('../infra/database')

exports.getPosts = function (filter = {}) {
  let query = 'select * from blog.post'
  const params = []
  const clauses = []

  if (filter.author_id) {
    clauses.push(`author_id = $${params.length + 1}`)
    params.push(filter.author_id)
  }

  if (clauses.length > 0) {
    query += ' where ' + clauses.join(' and ')
  }

  // Default sort
  query += ' order by date desc'

  return database.query(query, params)
}

exports.getPost = function (id) {
  return database.oneOrNone('select * from blog.post where id = $1', [id])
}

exports.getPostByTitle = function (title) {
  return database.oneOrNone('select * from blog.post where title = $1', [title])
}

exports.savePost = function (post) {
  // Note: Assuming post object now might have author_id, but sticking to existing contract for now unless modified.
  // If author_id is passed, we should insert it.
  if (post.author_id) {
    return database.one('insert into blog.post (title, content, author_id) values ($1, $2, $3) returning *', [post.title, post.content, post.author_id])
  }
  return database.one('insert into blog.post (title, content) values ($1, $2) returning *', [post.title, post.content])
}

exports.updatePost = function (id, post) {
  return database.none('update blog.post set title = $1, content = $2 where id = $3', [post.title, post.content, id])
}

exports.deletePost = function (id) {
  return database.none('delete from blog.post where id = $1', [id])
}
