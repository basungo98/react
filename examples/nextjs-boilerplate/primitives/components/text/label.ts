import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const Label = styled.label<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

Label.displayName = 'Primitives.Label'

export default Label
