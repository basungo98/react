import { getConnection, sql } from '../database'
import { encryptPassword } from '../utils/users'

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
      .input('p_cedula_editor', sql.VarChar(20), cedulaEditor)
      .execute('sp_eliminar_usuario')

    return result
  } catch (error) {
    return { error }
  }
}
