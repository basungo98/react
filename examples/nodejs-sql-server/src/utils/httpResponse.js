export const httpResponse = (response, data, httpStatusCode, error, rest) => {
  return response.status(httpStatusCode).json({
    data,
    httpStatusCode,
    error,
    ...rest,
  })
}
