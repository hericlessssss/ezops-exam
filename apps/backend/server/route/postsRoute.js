const express = require('express')
const router = express.Router()
const postsService = require('../service/postsService')

router.get('/posts', async function (req, res, next) {
  try {
    // Frontend sends ?filter[userId]=1 due to qs.stringify
    const filter = {}

    // Parse req.query['filter[userId]'] OR req.query.filter object if body-parser/qs extended is on
    // Express 'query parser' default is 'extended' (qs library), so nested objects work.
    // Let's assume req.query.filter.userId exists if sent.

    if (req.query.filter && req.query.filter.userId) {
      filter.author_id = req.query.filter.userId
    }

    const posts = await postsService.getPosts(filter)
    res.set('x-total-count', posts.length)
    res.json({ data: posts })
  } catch (e) {
    next(e)
  }
})

router.post('/posts', async function (req, res, next) {
  const post = req.body
  try {
    const newPost = await postsService.savePost(post)
    res.status(201).json(newPost)
  } catch (e) {
    next(e)
  }
})

router.put('/posts/:id', async function (req, res, next) {
  const post = req.body
  try {
    await postsService.updatePost(req.params.id, post)
    res.status(204).end()
  } catch (e) {
    next(e)
  }
})

router.delete('/posts/:id', async function (req, res, next) {
  try {
    await postsService.deletePost(req.params.id)
    res.status(204).end()
  } catch (e) {
    next(e)
  }
})

module.exports = router
