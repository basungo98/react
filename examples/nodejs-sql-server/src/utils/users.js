import bcrypt from 'bcryptjs'
import config from '../config'

export const encryptPassword = async (password) => {
    const salt = await bcrypt.genSalt(10)
    const result = await bcrypt.hash(password, salt)
    return result
}

export const comparePassword = async (password, receivedPassword) => {
    const result = await bcrypt.compare(password, receivedPassword)
    return result
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
    // eslint-disable-next-line no-restricted-syntax
    for (const [key, value] of Object.entries(config.roles)) {
        if (value === type) {
            return key
        }
    }
    return null
}
