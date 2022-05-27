import { getConnection, sql } from '../database'
import { encryptPassword, encryptUsername, getRoleType } from '../utils/users'

export const validateUser = async (usuario, password) => {
  try {
    const pool = await getConnection()

    const result = await pool
      .request()
      .input('p_usuario', sql.VarChar(150), usuario)
      .input('p_password', sql.VarChar(150), password)
      .execute('sp_validar_usuario')

    return result
  } catch (error) {
    return { error }
  }
}

export const validateDuplicatedUsers = async (cedula, usuario) => {
  try {
    const pool = await getConnection()

    const result = await pool
      .request()
      .input('p_usuario', sql.VarChar(150), usuario)
      .input('p_cedula', sql.VarChar(150), cedula)
      .execute('sp_validar_usuarios_duplicados')

    return result
  } catch (error) {
    return { error }
  }
}

export const createUser = async (userData) => {
  try {
    const pool = await getConnection()
    const {
      cedula,
      nombre,
      apelido1,
      apellido2,
      direccion,
      role,
      usuarioAgrega,
      usuario,
      password,
    } = userData

    const encryptedPassword = await encryptPassword(password)
    const encryptedUsername = await encryptUsername(usuario)
    const roleType = getRoleType(role)

    const result = await pool
      .request()
      .input('p_cedula', sql.VarChar(20), cedula)
      .input('p_nombre', sql.VarChar(20), nombre)
      .input('p_ape1', sql.VarChar(15), apelido1)
      .input('p_ape2', sql.VarChar(15), apellido2)
      .input('p_direccion', sql.VarChar(100), direccion)
      .input('p_tipo', sql.Int, roleType)
      .input('p_usu_ag', sql.VarChar(20), usuarioAgrega)
      .input('p_usuario', sql.VarChar(150), encryptedUsername)
      .input('p_password', sql.VarChar(150), encryptedPassword)
      .execute('sp_insertar_responsable')

    return result
  } catch (error) {
    return { error }
  }
}
