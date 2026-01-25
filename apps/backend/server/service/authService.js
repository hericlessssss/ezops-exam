const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
const db = require('../infra/database')

const SECRET = process.env.JWT_SECRET || 'dev_secret_key_123'
const ACCESS_EXP = '15m'
const REFRESH_EXP = '7d'

exports.login = async function (email, password) {
  const user = await db.oneOrNone('SELECT * FROM blog.users WHERE email = $1', [email])
  if (!user) throw new Error('User not found')

  const valid = await bcrypt.compare(password, user.password)
  if (!valid) throw new Error('Invalid password')

  const accessToken = jwt.sign({ id: user.id, email: user.email }, SECRET, { expiresIn: ACCESS_EXP })
  const refreshToken = jwt.sign({ id: user.id }, SECRET, { expiresIn: REFRESH_EXP })

  return {
    user: { id: user.id, name: user.name, email: user.email },
    accessToken,
    refreshToken
  }
}

exports.refresh = async function (refreshToken) {
  try {
    const decoded = jwt.verify(refreshToken, SECRET)
    const user = await db.oneOrNone('SELECT * FROM blog.users WHERE id = $1', [decoded.id])
    if (!user) throw new Error('User not found')

    const accessToken = jwt.sign({ id: user.id, email: user.email }, SECRET, { expiresIn: ACCESS_EXP })
    // Optional: Rotate refresh token here
    return { accessToken }
  } catch (e) {
    throw new Error('Invalid refresh token')
  }
}

exports.verifyToken = function (token) {
  return jwt.verify(token, SECRET)
}

exports.getUser = async function (id) {
  return db.oneOrNone('SELECT id, name, email FROM blog.users WHERE id = $1', [id])
}
