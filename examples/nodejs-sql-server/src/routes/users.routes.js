import { Router } from 'express'
import * as usersCtrl from '../controllers/users.controller'

const router = Router()

router.put('/update/password', usersCtrl.updatePassword)
router.put('/delete/user', usersCtrl.deleteUser)

export default router
