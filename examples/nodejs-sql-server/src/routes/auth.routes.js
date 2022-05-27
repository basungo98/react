import { Router } from 'express'
import * as authCtrl from '../controllers/auth.controller'
import { verifySignup } from '../middlewares'

const router = Router()

router.use((_, res, next) => {
  res.header(
    'Access-Control-Allow-Headers',
    'x-access-token, Origin, Content-Type, Accept',
  )
  next()
})

router.post(
  '/create',
  [verifySignup.checkDuplicatedUser, verifySignup.checkRoleExist],
  authCtrl.createUser,
)

router.post('/signin', authCtrl.signin)

export default router
