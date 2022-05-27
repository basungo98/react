import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import config from '../config'

export const encryptPassword = async (password) => {
  const salt = await bcrypt.genSalt(10)
  return await bcrypt.hash(password, salt)
}

export const compareUserId = async (password, receivedPassword) => {
  return await bcrypt.compare(password, receivedPassword)
}

export const encryptUsername = async (username) => {
  const salt = await bcrypt.genSalt(10)
  return await bcrypt.hash(username, salt)
}

export const compareUsername = async (username, receivedUsername) => {
  return await bcrypt.compare(username, receivedUsername)
}

export const getRoleType = (role) => {
  return config.roles[role.toLowerCase()]
}

export const getToken = (data, expiresIn) => {
  if (expiresIn) {
    return jwt.sign(data, config.secret, {
      expiresIn,
    })
  }

  return jwt.sign(data, config.secret)
}
