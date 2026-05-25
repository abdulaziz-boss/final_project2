@extends('superadmin.layouts.app')

@section('content')

<div class="container-fluid">

    {{-- HEADER --}}
    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h3 class="fw-bold mb-1">
                Active Admins
            </h3>

            <p class="text-muted mb-0">
                Daftar admin yang aktif
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

                            <th>Name</th>

                            <th>Email</th>

                            <th>Organization</th>

                            <th>Status</th>

                            <th width="180">
                                Action
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        @forelse($admins as $admin)

                            <tr>

                                {{-- NAME --}}
                                <td>

                                    <div class="fw-semibold">

                                        {{ $admin->name }}

                                    </div>

                                </td>


                                {{-- EMAIL --}}
                                <td>

                                    {{ $admin->email }}

                                </td>


                                {{-- ORGANIZATION --}}
                                <td>

                                    {{ $admin->organization->nama_organisasi ?? '-' }}

                                </td>


                                {{-- STATUS --}}
                                <td>

                                    <span class="badge bg-success">

                                        Active

                                    </span>

                                </td>


                                {{-- ACTION --}}
                                <td>

                                    <form
                                        action="{{ route('superadmin.admin.delete', $admin->id) }}"
                                        method="POST"
                                    >

                                        @csrf
                                        @method('DELETE')

                                        <button
                                            class="btn btn-danger btn-sm"
                                            onclick="return confirm('Hapus admin ini?')"
                                        >

                                            <i class="bi bi-trash-fill"></i>

                                            Remove

                                        </button>

                                    </form>

                                </td>

                            </tr>

                        @empty

                            <tr>

                                <td colspan="5" class="text-center py-4">

                                    <div class="text-muted">

                                        Tidak ada admin aktif

                                    </div>

                                </td>

                            </tr>

                        @endforelse

                    </tbody>

                </table>

            </div>


            {{-- PAGINATION --}}
            <div class="mt-3">

                {{ $admins->links() }}

            </div>

        </div>

    </div>

</div>

@endsection
