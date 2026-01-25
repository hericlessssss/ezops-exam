const express = require('express')
const router = express.Router()
const authService = require('../service/authService')

// Middleware to extract user from token
const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization
  if (!authHeader) return res.status(401).json({ error: 'No token provided' })

  const token = authHeader.split(' ')[1]
  try {
    const decoded = authService.verifyToken(token)
    req.user = decoded
    next()
  } catch (e) {
    res.status(401).json({ error: 'Invalid token' })
  }
}

router.get('/current', authenticate, async function (req, res) {
  try {
    const user = await authService.getUser(req.user.id)
    // Frontend expects wrapped data: { data: user }
    res.json({ data: user })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

module.exports = router
