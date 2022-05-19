import React from 'react'

import { Box } from '@primitives/components'

interface RawHtmlProps {
  className: string
  html: string | string[]
  onClick?: () => void
  sanitize: boolean
  tag: any
}

const RawHtml = ({
  className,
  html,
  sanitize,
  onClick,
  tag = 'div',
  ...props
}: RawHtmlProps) => (
  <Box
    as={tag}
    className={className}
    dangerouslySetInnerHTML={{ __html: html }}
    sanitize={sanitize}
    onClick={onClick ? onClick : null}
    {...props}
  />
)

RawHtml.displayName = 'Primitives.RawHtml'

export default RawHtml
