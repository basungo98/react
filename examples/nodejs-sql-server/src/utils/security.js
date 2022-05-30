import jwt from 'jsonwebtoken'
import config from '../config'

export const getToken = (data, expiresIn) => {
    if (expiresIn) {
        return jwt.sign(data, config.secret, {
            expiresIn,
        })
    }

    return jwt.sign(data, config.secret)
}

export const jwtVerify = (token) => {
    return jwt.verify(token, config.secret)
}
