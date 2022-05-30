import * as queriesAuth from '../queries/auth'
import httpResponse from '../utils/httpResponse'
import { getRoleName, comparePassword } from '../utils/users'
import { getToken } from '../utils/security'

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
                'ERROR: It was not possible to make updates to the database updates with the provided information.'
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

        const data = await queriesAuth.validateUser(usuario)

        const { error } = data

        if (error) {
            return httpResponse(res, [], 400, error)
        }

        const { recordset } = data

        if (!recordset || recordset.length === 0) {
            return httpResponse(res, [], 403, 'The username is incorrect.')
        }

        const {
            cedula,
            nombre,
            ape1,
            ape2,
            tipo,
            pass: dbPassword,
        } = recordset[0]

        const isPasswordEqual = await comparePassword(password, dbPassword)

        if (!isPasswordEqual) {
            return httpResponse(res, [], 403, 'The password is incorrect.')
        }

        const role = getRoleName(tipo)

        const responseData = {
            usuario,
            cedula,
            nombre,
            apellido1: ape1,
            apellido2: ape2,
            role,
        }

        const token = getToken({ usuario }, null)

        return httpResponse(res, responseData, 200, null, { token })
    } catch (error) {
        return httpResponse(res, [], 400, error)
    }
}
