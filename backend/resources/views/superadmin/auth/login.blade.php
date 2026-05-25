<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Super Admin Login</title>

    {{-- Bootstrap --}}
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body
    class="d-flex justify-content-center align-items-center"
    style="
        min-height: 100vh;
        background: linear-gradient(to right, #0f172a, #1e293b);
    "
>

    <div class="container">

        <div class="row justify-content-center">

            <div class="col-md-4">

                <div class="card border-0 shadow-lg rounded-4">

                    <div class="card-body p-5">

                        {{-- TITLE --}}
                        <div class="text-center mb-4">

                            <div class="mb-3">

                                <i
                                    class="bi bi-shield-lock-fill"
                                    style="font-size: 60px; color: #0d6efd;"
                                ></i>

                            </div>

                            <h3 class="fw-bold">
                                Super Admin
                            </h3>

                            <p class="text-muted">
                                Volunteer Dashboard Login
                            </p>

                        </div>


                        {{-- ERROR --}}
                        @if ($errors->any())

                            <div class="alert alert-danger">

                                {{ $errors->first() }}

                            </div>

                        @endif


                        {{-- SUCCESS --}}
                        @if(session('success'))

                            <div class="alert alert-success">

                                {{ session('success') }}

                            </div>

                        @endif


                        {{-- FORM --}}
                        <form action="/superadmin/login" method="POST">

                            @csrf

                            {{-- EMAIL --}}
                            <div class="mb-3">

                                <label class="form-label">
                                    Email
                                </label>

                                <div class="input-group">

                                    <span class="input-group-text">
                                        <i class="bi bi-envelope-fill"></i>
                                    </span>

                                    <input
                                        type="email"
                                        name="email"
                                        class="form-control"
                                        placeholder="Masukkan email"
                                        required
                                    >

                                </div>

                            </div>


                            {{-- PASSWORD --}}
                            <div class="mb-4">

                                <label class="form-label">
                                    Password
                                </label>

                                <div class="input-group">

                                    <span class="input-group-text">
                                        <i class="bi bi-lock-fill"></i>
                                    </span>

                                    <input
                                        type="password"
                                        name="password"
                                        class="form-control"
                                        placeholder="Masukkan password"
                                        required
                                    >

                                </div>

                            </div>


                            {{-- BUTTON --}}
                            <button class="btn btn-primary w-100 py-2">

                                <i class="bi bi-box-arrow-in-right me-2"></i>

                                Login

                            </button>

                        </form>

                    </div>

                </div>

            </div>

        </div>

    </div>

</body>

</html>
