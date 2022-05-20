import { DefaultProps } from '@primitives/types/styled-system'

import H1 from './h1'
import H2 from './h2'
import H3 from './h3'
import H4 from './h4'
import H5 from './h5'
import H6 from './h6'
import Label from './label'
import P from './p'
import Span from './span'

const TagMap: any = {
  h1: H1,
  h2: H2,
  h3: H3,
  h4: H4,
  h5: H5,
  h6: H6,
  label: Label,
  p: P,
  span: Span,
}

const Text = ({ textRef, tag, ...props }: DefaultProps | any) => {
  const Tag = tag ? TagMap[tag] : 'span'
  return Tag ? (
    <Tag ref={textRef} {...props} />
  ) : (
    <Span as={tag} ref={textRef} {...props} />
  )
}

Text.displayName = 'Primitives.Text'

export default Text
