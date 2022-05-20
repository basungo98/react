import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const Span = styled.span<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

Span.displayName = 'Primitives.Span'

export default Span
