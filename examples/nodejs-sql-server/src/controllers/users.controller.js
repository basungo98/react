import * as queriesUsers from '../queries/users'
import { httpResponse } from '../utils/httpResponse'

export const updatePassword = async (req, res) => {
  try {
    const data = await queriesUsers.updatePassword(req.body)

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

    return httpResponse(res, [], 200, null)
  } catch (error) {
    return res.status(500).json({
      data: [],
      httpStatusCode: 500,
      error: error.message,
    })
  }
}

export const deleteUser = async (req, res) => {
  try {
    const data = await queriesUsers.deleteUser(req.body)

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

    return httpResponse(res, [], 200, null)
  } catch (error) {
    return res.status(500).json({
      data: [],
      httpStatusCode: 500,
      error: error.message,
    })
  }
}
