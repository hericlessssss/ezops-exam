const express = require('express')
const router = express.Router()
const authService = require('../service/authService')

router.post('/login', async function (req, res) {
  const { email, password } = req.body
  try {
    const result = await authService.login(email, password)

    // Frontend expects Refresh Token in Cookie (HttpOnly)
    res.cookie('refreshToken', result.refreshToken, {
      httpOnly: true,
      secure: false, // Set to true in Prod if SSL enabled (which it is)
      sameSite: 'Strict', // or 'None' if cross-domain? Frontend is DIFFERENT domain!
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    })

    // Frontend expects wrapped data: { data: { accessToken: "..." } }
    res.json({ data: { accessToken: result.accessToken } })
  } catch (e) {
    res.status(401).json({ error: e.message })
  }
})

router.post('/refresh-tokens', async function (req, res) {
  // Read from Cookie
  const refreshToken = req.cookies.refreshToken
  if (!refreshToken) return res.status(401).json({ error: 'No refresh token' })

  try {
    const result = await authService.refresh(refreshToken)
    res.json({ data: { accessToken: result.accessToken } })
  } catch (e) {
    res.status(401).clearCookie('refreshToken').json({ error: e.message })
  }
})

router.post('/logout', function (req, res) {
  res.clearCookie('refreshToken')
  res.json({ data: { success: true } })
})

module.exports = router
