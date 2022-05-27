import { Router } from 'express'
import * as usersCtrl from '../controllers/users.controller'
import { verifySignup } from '../middlewares'

const router = Router()

router.post(
  '/create',
  [verifySignup.checkDuplicatedUser, verifySignup.checkRoleExist],
  usersCtrl.createUser,
)

export default router
