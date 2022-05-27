import config from '../config'
import { httpResponse } from '../utils/httpResponse'
import { jwtVerify } from '../utils/users'
import * as queriesAuth from '../queries/auth'

export const verifyToken = async (req, res, next) => {
  let token = req.headers['x-access-token']
  const secret = config.secret

  if (!token) {
    return httpResponse(res, [], 403, 'No token provided')
  } else if (!secret) {
    return httpResponse(
      res,
      [],
      403,
      'ERROR: Server is not able to verify the token by an internal configuration error.',
    )
  }

  try {
    const decoded = jwtVerify(token)

    const { usuario } = decoded

    const data = await queriesAuth.validateUser(usuario)

    const { error } = data

    if (error) {
      return httpResponse(res, [], 400, error)
    }

    const { recordset } = data

    if (!recordset || recordset.length === 0) {
      return httpResponse(res, [], 401, 'Unauthorized!')
    }

    next()
  } catch (error) {
    return httpResponse(res, [], 401, 'Unauthorized!')
  }
}
