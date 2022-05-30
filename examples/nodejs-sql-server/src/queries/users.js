import { getConnection, sql } from '../database'
import { encryptPassword, getRoleType } from '../utils/users'

export const updatePassword = async (bodyData) => {
    try {
        const pool = await getConnection()

        const { cedula, password } = bodyData

        const encryptedPassword = await encryptPassword(password)

        const result = await pool
            .request()
            .input('p_cedula', sql.VarChar(20), cedula)
            .input('p_password', sql.VarChar(150), encryptedPassword)
            .execute('sp_actualizar_password')

        return result
    } catch (error) {
        return { error }
    }
}

export const deleteUser = async (bodyData) => {
    try {
        const pool = await getConnection()

        const { cedula, cedulaEditor } = bodyData

        const result = await pool
            .request()
            .input('p_cedula', sql.VarChar(20), cedula)
            .input('usu_bor', sql.VarChar(20), cedulaEditor)
            .execute('sp_eliminar_usuario')

        return result
    } catch (error) {
        return { error }
    }
}

export const updateUser = async (bodyData) => {
    try {
        const pool = await getConnection()

        const {
            cedula,
            nombre,
            apelido1,
            apellido2,
            direccion,
            role,
            cedulaEditor,
        } = bodyData

        const roleType = getRoleType(role)

        const result = await pool
            .request()
            .input('p_cedula', sql.VarChar(20), cedula)
            .input('p_nombre', sql.VarChar(20), nombre)
            .input('p_ape1', sql.VarChar(15), apelido1)
            .input('p_ape2', sql.VarChar(15), apellido2)
            .input('p_direccion', sql.VarChar(100), direccion)
            .input('p_tipo', sql.Int, roleType)
            .input('p_usu_edi', sql.VarChar(20), cedulaEditor)
            .execute('sp_actualizar_responsable')

        return result
    } catch (error) {
        return { error }
    }
}
