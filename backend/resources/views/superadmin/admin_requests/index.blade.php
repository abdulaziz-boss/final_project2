@extends('superadmin.layouts.app')

@section('content')

<div class="container-fluid">

    {{-- HEADER --}}
    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h3 class="fw-bold mb-1">
                Admin Requests
            </h3>

            <p class="text-muted mb-0">
                Daftar pengajuan admin organisasi
            </p>

        </div>

    </div>


    {{-- ALERT --}}
    @if(session('success'))

        <div class="alert alert-success">

            {{ session('success') }}

        </div>

    @endif

    @if(session('error'))

        <div class="alert alert-danger">

            {{ session('error') }}

        </div>

    @endif


    {{-- TABLE --}}
    <div class="card border-0 shadow-sm">

        <div class="card-body">

            <div class="table-responsive">

                <table class="table align-middle">

                    <thead class="table-light">

                        <tr>

                            <th>User</th>

                            <th>Email</th>

                            <th>Organization</th>

                            <th>Status</th>

                            <th width="200">
                                Action
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        @forelse($requests as $request)

                            <tr>

                                {{-- USER --}}
                                <td>

                                    <div class="fw-semibold">
                                        {{ $request->name }}
                                    </div>

                                </td>


                                {{-- EMAIL --}}
                                <td>

                                    {{ $request->email }}

                                </td>


                                {{-- ORGANIZATION --}}
                                <td>

                                    <div class="fw-semibold">

                                        {{ $request->organization->nama_organisasi ?? '-' }}

                                    </div>

                                    <small class="text-muted">

                                        {{ $request->organization->website ?? '-' }}

                                    </small>

                                </td>


                                {{-- STATUS --}}
                                <td>

                                    <span class="badge bg-warning">

                                        Pending

                                    </span>

                                </td>


                                {{-- ACTION --}}
                                <td>

                                    <div class="d-flex gap-2">

                                        {{-- APPROVE --}}
                                        <form
                                            action="{{ route('superadmin.admin.approve', $request->id) }}"
                                            method="POST"
                                        >

                                            @csrf

                                            <button
                                                class="btn btn-success btn-sm"
                                                onclick="return confirm('Approve admin ini?')"
                                            >

                                                <i class="bi bi-check-circle"></i>

                                                Approve

                                            </button>

                                        </form>


                                        {{-- REJECT --}}
                                        <form
                                            action="{{ route('superadmin.admin.reject', $request->id) }}"
                                            method="POST"
                                        >

                                            @csrf

                                            <button
                                                class="btn btn-danger btn-sm"
                                                onclick="return confirm('Tolak request ini?')"
                                            >

                                                <i class="bi bi-x-circle"></i>

                                                Reject

                                            </button>

                                        </form>

                                    </div>

                                </td>

                            </tr>

                        @empty

                            <tr>

                                <td colspan="5" class="text-center py-4">

                                    <div class="text-muted">

                                        Belum ada request admin

                                    </div>

                                </td>

                            </tr>

                        @endforelse

                    </tbody>

                </table>

            </div>


            {{-- PAGINATION --}}
            <div class="mt-3">

                {{ $requests->links() }}

            </div>

        </div>

    </div>

</div>

@endsection
