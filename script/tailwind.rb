tailwind_path = 'app/assets/stylesheets/application.tailwind.css'
tailwind_imports = <<~CSS
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  @layer components {
    body {
      background: #f6f6f6;
      color: #212122;
    }

    .btn {
      @apply py-2 px-6 text-lg font-semibold rounded border border-slate-200 cursor-pointer flex items-center justify-center shadow-sm;
    }

    .btn-primary {
      @apply bg-black text-white;
      background: linear-gradient(
        180deg,
        rgba(17, 18, 20, 0.75) 4.87%,
        rgba(12, 13, 15, 0.9) 75.88%
      );
      border: 1px solid #212122;
      box-shadow:
        0 0 0 1px rgba(255, 255, 255, 0.2),
        0 0 0 2px rgba(255, 255, 255, 0.1),
        inset 0 0 0 1px rgba(255, 255, 255, 0.2);
    }

    .btn-secondary {
      @apply bg-slate-100 text-slate-800;
      background: linear-gradient(0deg, #f6f6f6 4.87%, #fff 75.88%);
      border: 1px solid #d9d9d9;
      box-shadow:
        0 0 0 1px rgba(255, 255, 255, 0.4),
        0 0 0 2px rgba(255, 255, 255, 0.2),
        inset 0 0 0 1px rgba(255, 255, 255, 0.3);
    }

    .container {
      max-width: 960px;
    }

    .container-sm {
      max-width: 560px;
    }

    .card {
      @apply w-full bg-white p-12 rounded-lg shadow-sm border border-slate-300;
    }

    .label {
      @apply block text-sm font-medium text-slate-600;
    }
  }

  body {
    font-family: "Inter", sans-serif;
  }

  .font-fancy {
    font-family: "Roboto Condensed", sans-serif;
  }

  #notices {
    position: fixed;
    bottom: 20px;
    right: auto;
    left: 50%;
    transform: translateX(-50%);
    background-color: #000;
    color: #fff;
    font-size: 17px;
    padding: 10px 20px;
    border-radius: 10px;
  }

  .pagy {
    @apply flex space-x-1 font-semibold text-sm text-slate-500;
    a:not(.gap) {
      @apply block rounded px-3 py-1 bg-slate-200;
      &:hover {
        @apply bg-slate-300;
      }
      &:not([href]) {
        @apply text-slate-300 bg-slate-100 cursor-default;
      }
      &.current {
        @apply text-white bg-slate-400;
      }
    }
    label {
      @apply inline-block whitespace-nowrap bg-slate-200 rounded px-3 py-0.5;
      input {
        @apply bg-slate-100 border-none rounded-md;
      }
    }
  }

  .videoWrapper {
    position: relative;
    padding-bottom: 56.25%; /* 16:9 */
    padding-top: 25px;
    height: 0;
  }

  .videoWrapper iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }
CSS

remove_file tailwind_path
create_file tailwind_path, tailwind_imports
