import { getConnection, sql } from '../database'

export const getProtectionAreasById = async (req, res) => {
  try {
    const pool = await getConnection()

    const result = await pool
      .request()
      .input('p_boleta', sql.BigInt, req.params.id)
      .execute('spr_obtener_areas_proteccion_por_boleta')
    return res
      .status(200)
      .json({ data: result.recordset, httpStatusCode: 200, error: null })
  } catch (error) {
    res.status(500)
    res.send(error.message)
  }
}
