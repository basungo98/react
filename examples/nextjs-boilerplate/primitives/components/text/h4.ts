import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const H4 = styled.h4<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

H4.displayName = 'Primitives.H4'

export default H4
