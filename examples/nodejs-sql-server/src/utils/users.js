import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import config from '../config'

export const encryptPassword = async (password) => {
  const salt = await bcrypt.genSalt(10)
  return await bcrypt.hash(password, salt)
}

export const comparePassword = async (password, receivedPassword) => {
  return await bcrypt.compare(password, receivedPassword)
}

export const compareUserId = async (userId, receivedUserId) => {
  return userId.toLowerCase() === receivedUserId.toLowerCase()
}

export const compareUsername = async (username, receivedUsername) => {
  return username.toLowerCase() === receivedUsername.toLowerCase()
}

export const getRoleType = (role) => {
  return config.roles[role.toLowerCase()]
}

export const getRoleName = (type) => {
  for (const [key, value] of Object.entries(config.roles)) {
    if (value === type) {
      return key
    }
  }
  return null
}

export const getToken = (data, expiresIn) => {
  if (expiresIn) {
    return jwt.sign(data, config.secret, {
      expiresIn,
    })
  }

  return jwt.sign(data, config.secret)
}
