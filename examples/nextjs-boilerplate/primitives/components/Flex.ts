import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const Box = styled.div<DefaultProps>`
  display: flex;
  ${styleSystemProps};
`

Box.displayName = 'Primitives.Box'

export default Box
