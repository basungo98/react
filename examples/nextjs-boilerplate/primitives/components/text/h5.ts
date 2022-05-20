import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const H5 = styled.h5<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

H5.displayName = 'Primitives.H5'

export default H5
