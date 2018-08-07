context("API wrappers")

without_internet({
    test_that("HTTP verb functions make requests", {
        expect_GET(my_GET("http://httpbin.org/"))
        expect_PUT(my_PUT("http://httpbin.org/"))
        expect_POST(my_POST("http://httpbin.org/"))
        expect_PATCH(my_PATCH("http://httpbin.org/"))
        expect_DELETE(my_DELETE("http://httpbin.org/"))
    })
    test_that("Our user-agent string is set", {
        expect_GET(
            expect_header(
                my_GET("http://httpbin.org/"),
                "user-agent: yourpackagename/0.1.0"
            )
        )
    })
})

with_mock_api({
    test_that("Successful requests are handled", {
        expect_identical(
            my_GET("https://example.com/get"),
            list(success="Yes!")
        )
    })

    test_that("Bad requests return an error", {
        expect_error(my_GET("https://example.com/404"),
            "Not Found")
    })
})
