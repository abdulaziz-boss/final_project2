@extends('superadmin.layouts.app')

@section('content')

<div class="container-fluid">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h3 class="fw-bold">
                Users Management
            </h3>

            <p class="text-muted">
                Daftar semua user aplikasi
            </p>

        </div>

    </div>


    @if(session('success'))

        <div class="alert alert-success">

            {{ session('success') }}

        </div>

    @endif


    <div class="card border-0 shadow-sm">

        <div class="card-body">

            <div class="table-responsive">

                <table class="table align-middle">

                    <thead class="table-light">

                        <tr>

                            <th>Name</th>

                            <th>Email</th>

                            <th>Role</th>

                            <th>Status</th>

                            <th width="180">
                                Action
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        @forelse($users as $user)

                            <tr>

                                <td>
                                    {{ $user->name }}
                                </td>

                                <td>
                                    {{ $user->email }}
                                </td>

                                <td>
                                    @if($user->last_seen &&
                                        $user->last_seen->gt(now()->subMinutes(5)))

                                        <span class="badge bg-success">
                                            Online
                                        </span>

                                    @else

                                        <span class="badge bg-secondary">
                                            Offline
                                        </span>

                                    @endif

                                    @if($user->role == 'super_admin')

                                        <span class="badge bg-dark">
                                            Super Admin
                                        </span>

                                    @elseif($user->role == 'admin')

                                        <span class="badge bg-primary">
                                            Admin
                                        </span>

                                    @else

                                        <span class="badge bg-secondary">
                                            User
                                        </span>

                                    @endif

                                </td>

                                <td>

                                    @if($user->is_active)

                                        <span class="badge bg-success">
                                            Active
                                        </span>

                                    @else

                                        <span class="badge bg-danger">
                                            Inactive
                                        </span>

                                    @endif

                                </td>

                                <td>

                                    <form
                                        action="{{ route('superadmin.users.toggle', $user->id) }}"
                                        method="POST"
                                    >

                                        @csrf

                                        <button
                                            class="btn btn-sm
                                            {{ $user->is_active ? 'btn-danger' : 'btn-success' }}"
                                        >

                                            {{ $user->is_active ? 'Disable' : 'Enable' }}

                                        </button>

                                    </form>

                                </td>

                            </tr>

                        @empty

                            <tr>

                                <td colspan="5" class="text-center py-4">

                                    Tidak ada user

                                </td>

                            </tr>

                        @endforelse

                    </tbody>

                </table>

            </div>


            <div class="mt-3">

                {{ $users->links() }}

            </div>

        </div>

    </div>

</div>

@endsection
