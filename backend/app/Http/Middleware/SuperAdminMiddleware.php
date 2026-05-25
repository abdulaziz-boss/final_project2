<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class SuperAdminMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        // cek login
        if (!Auth::check()) {

            return redirect('/superadmin/login');
        }

        // cek role
        if (Auth::user()->role !== 'super_admin') {

            abort(403, 'Akses ditolak');
        }

        return $next($request);
    }
}
