import React, { forwardRef } from 'react'
import styled from 'styled-components'
import { ImageProps } from '@primitives/types/styled-system'
import { imageStyleSystemProps } from '@primitives/shared/styled-system-props'

interface ImageWithAttrProps {
  imageHeight: string
  imageWidth: string
}

interface ImagePrimitiveProps extends ImageWithAttrProps {
  alt?: string
}

type ImageType = React.HTMLProps<HTMLImageElement>

const ImageWithAttr: any = styled.img.attrs(
  ({ imageHeight = '', imageWidth = '', ...rest }: ImageWithAttrProps) => ({
    height: imageHeight,
    width: imageWidth,
    ...rest,
  }),
)``

const Image = styled.img<ImageProps>`
  ${imageStyleSystemProps};
`

const ImagePrimitive = forwardRef<ImageType, ImagePrimitiveProps>(
  ({ alt, imageHeight, imageWidth, ...props }, ref) => (
    <Image
      alt={alt}
      as={imageHeight && imageWidth ? ImageWithAttr : null}
      imageHeight={imageHeight}
      imageWidth={imageWidth}
      ref={ref}
      {...props}
    />
  ),
)

ImagePrimitive.displayName = 'Primitives.Image'

export default ImagePrimitive
