<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Super Admin Dashboard</title>

    {{-- Bootstrap --}}
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body style="background-color: #f5f6fa;">

    <div class="d-flex">

        {{-- SIDEBAR --}}
        <div
            class="bg-dark text-white p-3"
            style="width: 250px; min-height: 100vh;"
        >

            <h4 class="mb-4">
                Volunteer Admin
            </h4>

            <ul class="nav flex-column">

                <li class="nav-item mb-2">

                    <a
                        href="{{ route('superadmin.dashboard') }}"
                        class="nav-link text-white {{ request()->routeIs('superadmin.dashboard') ? 'bg-primary rounded' : '' }}"
                    >
                        <i class="bi bi-grid-fill"></i>
                        Dashboard
                    </a>

                </li>

                <li class="nav-item mb-2">

                    <a
                        href="{{ route('superadmin.admin.requests') }}"
                        class="nav-link text-white {{ request()->routeIs('superadmin.admin.requests') ? 'bg-primary rounded' : '' }}""
                    >
                        <i class="bi bi-person-plus-fill"></i>
                        Request Admin
                    </a>

                </li>

                <li class="nav-item mb-2">

                    <a
                        href="{{ route('superadmin.admins') }}"
                        class="nav-link text-white {{ request()->routeIs('superadmin.admins') ? 'bg-primary rounded' : '' }}"
                    >
                        <i class="bi bi-people-fill"></i>
                        Admin Aktif
                    </a>

                </li>

                <li class="nav-item mb-2">

                    <a
                        href="{{ route('superadmin.users') }}"
                        class="nav-link text-white"
                    >

                        <i class="bi bi-person-lines-fill me-2"></i>

                        Users

                    </a>

                </li>

                <li class="nav-item mt-4">

                    <form
                        action="{{ route('superadmin.logout') }}"
                        method="POST"
                    >
                        @csrf

                        <button class="btn btn-danger w-100">

                            <i class="bi bi-box-arrow-right"></i>
                            Logout

                        </button>

                    </form>

                </li>

            </ul>

        </div>

        {{-- CONTENT --}}
        <div class="flex-grow-1">

            {{-- NAVBAR --}}
            <nav class="navbar navbar-light bg-white shadow-sm px-4">

                <span class="navbar-brand mb-0 h5">
                    Super Admin Panel
                </span>

                <span>
                    {{ auth()->user()->name }}
                </span>

            </nav>

            {{-- PAGE CONTENT --}}
            <div class="p-4">

                @yield('content')

            </div>

        </div>

    </div>

    {{-- Bootstrap JS --}}
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    {{-- Chart JS --}}
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    @stack('scripts')

</body>

</html>
