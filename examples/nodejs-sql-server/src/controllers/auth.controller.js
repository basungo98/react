import * as queriesAuth from '../queries/auth'
import { httpResponse } from '../utils/httpResponse'
import { getToken } from '../utils/users'

export const createUser = async (req, res) => {
  try {
    const data = await queriesAuth.createUser(req.body)

    const { error } = data

    if (error) {
      return httpResponse(res, [], 400, error)
    }

    const { returnValue } = data

    if (returnValue !== 0) {
      return httpResponse(
        res,
        [],
        400,
        'ERROR: It was not possible to make updates to the database updates with the provided information.',
      )
    }

    const { usuario } = req.body

    const token = getToken({ usuario }, null)

    return httpResponse(res, [], 200, null, { token })
  } catch (error) {
    return res.status(500).json({
      data: [],
      httpStatusCode: 500,
      error: error.message,
    })
  }
}

export const signin = async (req, res) => {
  try {
    const { usuario, password } = req.body

    const data = await validateUser(usuario, password)

    if (!data) {
      return httpResponse(res, [], 400, 'Password or Username is incorrect')
    }

    const { recordset } = data

    if (!recordset) {
      return httpResponse(res, [], 400, 'db error')
    }

    return httpResponse(res, recordset, 200, null)

    // // Request body email can be an email or username
    // const userFound = await User.findOne({ email: req.body.email }).populate(
    //   'roles',
    // )

    // if (!userFound) return res.status(400).json({ message: 'User Not Found' })

    // const matchPassword = await User.compareUserId(
    //   req.body.password,
    //   userFound.password,
    // )

    // if (!matchPassword)
    //   return res.status(401).json({
    //     token: null,
    //     message: 'Invalid Password',
    //   })

    // const token = jwt.sign({ id: userFound._id }, config.SECRET, {
    //   expiresIn: 86400, // 24 hours
    // })

    // res.json({ token })
  } catch (error) {
    return httpResponse(res, [], 400, error)
  }
}
