import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const Input = styled.input<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

Input.displayName = 'Primitives.Input'

export default Input
