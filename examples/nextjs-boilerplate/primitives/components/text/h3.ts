import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const H3 = styled.h3<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

H3.displayName = 'Primitives.H3'

export default H3
