import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const H5 = styled.h5<DefaultProps>`
  ${styleSystemProps};
`

H5.displayName = 'Primitives.H5'

export default H5
