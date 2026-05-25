<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\SuperAdmin\AuthController;
use App\Http\Controllers\SuperAdmin\DashboardController;
use App\Http\Controllers\SuperAdmin\AdminRequestController;
use App\Http\Controllers\SuperAdmin\AdminManagementController;
use App\Http\Controllers\SuperAdmin\UserManagementController;

//SUPER ADMIN AUTH


Route::prefix('superadmin')->group(function () {

    // login page
    Route::get(
        '/login',
        [AuthController::class, 'showLogin']
    )->name('superadmin.login');

    // proses login
    Route::post(
        '/login',
        [AuthController::class, 'login']
    );

});


//SUPER ADMIN PROTECTED

Route::middleware(['auth', 'superadmin'])
->prefix('superadmin')
->group(function () {

    // dashboard
    Route::get(
        '/dashboard',
        [DashboardController::class, 'index']
    )->name('superadmin.dashboard');


    //ADMIN REQUEST


    Route::get(
        '/admin-requests',
        [AdminRequestController::class, 'index']
    )->name('superadmin.admin.requests');

    Route::post(
        '/admin-requests/approve/{id}',
        [AdminRequestController::class, 'approve']
    )->name('superadmin.admin.approve');

    Route::post(
        '/admin-requests/reject/{id}',
        [AdminRequestController::class, 'reject']
    )->name('superadmin.admin.reject');


    // ADMIN MANAGEMENT

    Route::get(
        '/admins',
        [AdminManagementController::class, 'index']
    )->name('superadmin.admins');

    Route::delete(
        '/admins/{id}',
        [AdminManagementController::class, 'destroy']
    )->name('superadmin.admin.delete');

    Route::get(
    '/users',
        [UserManagementController::class, 'index']
    )->name('superadmin.users');

    Route::post(
        '/users/toggle-status/{id}',
        [UserManagementController::class, 'toggleStatus']
    )->name('superadmin.users.toggle');

    //LOGOUT


    Route::post(
        '/logout',
        [AuthController::class, 'logout']
    )->name('superadmin.logout');

});
