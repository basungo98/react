// import jwt from 'jsonwebtoken'
// import config from '../config'
// import User from '../models/User'

// export const verifyToken = async (req, res, next) => {
//   let token = req.headers['x-access-token']
//   const secret = config.SECRET

//   if (!token)
//     return res
//       .status(403)
//       .json({ data: [], httpStatusCode: 403, error: 'No token provided' })
//   else if (!secret) {
//     return res
//       .status(403)
//       .json({
//         data: [],
//         httpStatusCode: 403,
//         error:
//           'ERROR: Server is not able to verify the token by an internal configuration error.',
//       })
//   }

//   try {
//     const decoded = jwt.verify(token, config.SECRET)
//     req.userId = decoded.id

//     const user = await User.findById(req.userId, { password: 0 })
//     if (!user) return res.status(404).json({ message: 'No user found' })

//     next()
//   } catch (error) {
//     return res.status(401).json({ message: 'Unauthorized!' })
//   }
// }

// export const isAdmin = async (req, res, next) => {
//   try {
//     const { tipoUsuario } = req.body

//     if (tipoUsuario == 1) {
//       next()
//       return
//     }

//     return res
//       .status(403)
//       .json({ data: [], httpStatusCode: 403, error: 'Require Admin Role!' })
//   } catch (error) {
//     console.log(error)
//     return res.status(500).json({ data: [], httpStatusCode: 500, error })
//   }
// }
