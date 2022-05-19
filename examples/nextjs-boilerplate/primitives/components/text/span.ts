import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const Span = styled.span<DefaultProps>`
  ${styleSystemProps};
`

Span.displayName = 'Primitives.Span'

export default Span
