import { validateDuplicatedUsers } from '../queries/auth'
import { compareUserId, compareUsername } from '../utils/users'
import { httpResponse } from '../utils/httpResponse'
import config from '../config'

const checkDuplicatedUser = async (req, res, next) => {
  try {
    const { cedula, usuario } = req.body
    const data = await validateDuplicatedUsers(cedula, usuario)

    const { error } = data

    if (error) {
      return httpResponse(res, [], 404, error)
    }

    const { recordset } = data

    if (!recordset || recordset.length === 0) {
      return next()
    }

    const { cedula: dbCedula, usuario: dbUsuario } = recordset[0]

    const userIdIsDuplicated = await compareUserId(cedula, dbCedula)
    const usernameIsDuplicated = await compareUsername(usuario, dbUsuario)

    if (userIdIsDuplicated) {
      return httpResponse(res, [], 403, `User id ${cedula} already exist`)
    }

    if (usernameIsDuplicated) {
      return httpResponse(res, [], 403, `Username ${usuario} already exist`)
    }

    next()
  } catch (error) {
    return httpResponse(res, [], 500, error)
  }
}

const checkRoleExist = (req, res, next) => {
  const { role } = req.body

  if (!role || config.roles[role.toLowerCase()] === undefined) {
    return httpResponse(res, [], 400, `Invalid role ${role}`)
  }

  next()
}

export { checkDuplicatedUser, checkRoleExist }
