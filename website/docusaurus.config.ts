import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const CF_BEACON_TOKEN = 'c2690c3444a34bc4aed5966aa3778e88';

const config: Config = {
  title: 'AxShell',
  tagline: 'A wayland shell built for you',
  favicon: 'favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://mora1ss.github.io',
  baseUrl: '/',
  trailingSlash: false,

  organizationName: 'mora1ss',
  projectName: 'axshell',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  scripts: [
    {
      src: 'https://static.cloudflareinsights.com/beacon.min.js',
      defer: true,
      'data-cf-beacon': JSON.stringify({token: CF_BEACON_TOKEN, spa: true}),
    },
  ],

  headTags: [
    {
      tagName: 'link',
      attributes: {rel: 'icon', href: '/favicon-48.png', type: 'image/png', sizes: '48x48'},
    },
    {
      tagName: 'link',
      attributes: {rel: 'icon', href: '/favicon-192.png', type: 'image/png', sizes: '192x192'},
    },
    {
      tagName: 'link',
      attributes: {rel: 'apple-touch-icon', href: '/apple-touch-icon.png'},
    },
  ],

  themes: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        docsRouteBasePath: '/',
        docsDir: '../docs',
        indexBlog: false,
        searchBarShortcutHint: false,
        highlightSearchTermsOnTargetPage: false,
        explicitSearchResultPath: true,
      },
    ],
  ],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
          path: '../docs',
          editUrl: 'https://github.com/mora1ss/axshell/edit/master/docs/',
        },
        blog: false,
        theme: {
          customCss: ['./src/css/custom.css', './src/css/docs.css'],
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/social-card.jpg',
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: false,
    },
    navbar: {
      title: 'AxShell',
      logo: {
        alt: 'AxShell Logo',
        src: 'img/logo-light.svg',
        srcDark: 'img/logo-dark.svg',
        width: 32,
        height: 32,
      },
      items: [
        {
          to: '/overview',
          label: 'Documentation',
          position: 'left',
        },
      ],
    },
    footer: {
      style: 'dark',
      logo: {
        alt: 'AxShell Logo',
        src: 'img/logo-light.svg',
        srcDark: 'img/logo-dark.svg',
        width: 44,
        height: 44,
      },
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Overview',
              to: '/overview',
            },
            {
              label: 'Installation',
              to: '/installation',
            },
            {
              label: 'Variables',
              to: '/configure',
            },
          ],
        },
        {
          title: 'Project',
          items: [{ label: 'GitHub', href: 'https://github.com/mora1ss/axshell' }],
        },
      ],
      copyright: `A desktop shell built for YOU. Copyright © ${new Date().getFullYear()} AxShell.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['bash', 'ini', 'json', 'lua', 'nix'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
