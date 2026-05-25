@extends('superadmin.layouts.app')

@section('content')

<div class="container-fluid">

    {{-- TITLE --}}
    <div class="mb-4">

        <h3 class="fw-bold">
            Dashboard Super Admin
        </h3>

        <p class="text-muted">
            Selamat datang di panel super admin volunteer app
        </p>

    </div>


    {{-- STATISTIC CARDS --}}
    <div class="row">

        {{-- TOTAL USERS --}}
        <div class="col-md-3 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center">

                        <div>

                            <h6 class="text-muted">
                                Total Users
                            </h6>

                            <h2 class="fw-bold">
                                {{ $totalUsers }}
                            </h2>

                        </div>

                        <div class="fs-1 text-primary">
                            <i class="bi bi-people-fill"></i>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        {{-- TOTAL ADMINS --}}
        <div class="col-md-3 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center">

                        <div>

                            <h6 class="text-muted">
                                Total Admin
                            </h6>

                            <h2 class="fw-bold">
                                {{ $totalAdmins }}
                            </h2>

                        </div>

                        <div class="fs-1 text-success">
                            <i class="bi bi-person-badge-fill"></i>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        {{-- PENDING REQUEST --}}
        <div class="col-md-3 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center">

                        <div>

                            <h6 class="text-muted">
                                Pending Request
                            </h6>

                            <h2 class="fw-bold">
                                {{ $pendingRequests }}
                            </h2>

                        </div>

                        <div class="fs-1 text-warning">
                            <i class="bi bi-clock-history"></i>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        {{-- TOTAL ORGANIZATION --}}
        <div class="col-md-3 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center">

                        <div>

                            <h6 class="text-muted">
                                Total Organization
                            </h6>

                            <h2 class="fw-bold">
                                {{ $totalOrganizations }}
                            </h2>

                        </div>

                        <div class="fs-1 text-danger">
                            <i class="bi bi-building"></i>
                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>


    {{-- SECOND ROW --}}
    <div class="row">

        {{-- TOTAL OPPORTUNITY --}}
        <div class="col-md-4 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <h6 class="text-muted">
                        Total Volunteer Activity
                    </h6>

                    <h2 class="fw-bold">
                        {{ $totalOpportunities }}
                    </h2>

                </div>

            </div>

        </div>


        {{-- CHART --}}
        <div class="col-md-8 mb-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body">

                    <h5 class="mb-4">
                        User Statistics
                    </h5>

                    <canvas id="userChart"></canvas>

                </div>

            </div>

        </div>

    </div>


    {{-- RECENT REQUEST --}}
    <div class="card border-0 shadow-sm">

        <div class="card-body">

            <div class="d-flex justify-content-between align-items-center mb-4">

                <h5 class="mb-0">
                    Recent Admin Requests
                </h5>

                <a
                    href="{{ route('superadmin.admin.requests') }}"
                    class="btn btn-sm btn-primary"
                >
                    View All
                </a>

            </div>

            <div class="table-responsive">

                <table class="table align-middle">

                    <thead>

                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Organization</th>
                            <th>Status</th>
                        </tr>

                    </thead>

                    <tbody>

                        @forelse($recentRequests as $request)

                            <tr>

                                <td>
                                    {{ $request->name }}
                                </td>

                                <td>
                                    {{ $request->email }}
                                </td>

                                <td>
                                    {{ $request->organization->nama_organisasi ?? '-' }}
                                </td>

                                <td>
                                    <span class="badge bg-warning">
                                        Pending
                                    </span>
                                </td>

                            </tr>

                        @empty

                            <tr>

                                <td colspan="4" class="text-center text-muted">
                                    Tidak ada request terbaru
                                </td>

                            </tr>

                        @endforelse

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

@endsection


@push('scripts')

<script>

    const ctx = document.getElementById('userChart');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Users', 'Admins', 'Pending'],
            datasets: [{
                label: 'Statistics',
                data: [
                    {{ $totalUsers }},
                    {{ $totalAdmins }},
                    {{ $pendingRequests }}
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
        }
    });

</script>

@endpush
