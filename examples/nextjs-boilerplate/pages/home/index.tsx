import type { NextPage } from 'next'
import Primitives from '@primitives'

const Home: NextPage = () => {
  return (
    <Primitives.Box>
      <Primitives.Text tag="h1" fontSize={[0, 0, 5]}>
        Home page
        <Primitives.Button>test</Primitives.Button>
      </Primitives.Text>
    </Primitives.Box>
  )
}

export default Home
