import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const Input = styled.input<DefaultProps>`
  ${styleSystemProps};
`

Input.displayName = 'Primitives.Input'

export default Input
