import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const Label = styled.label<DefaultProps>`
  ${styleSystemProps};
`

Label.displayName = 'Primitives.Label'

export default Label
